import React, { Component } from 'react';
import * as R from 'ramda';
import {
  NativeModules,
  StyleSheet,
  ActivityIndicator,
  NativeEventEmitter,
  View,
  Alert
} from 'react-native';
import { connectToStore } from '@applicaster/zapp-react-native-redux';
import ProvidersList from './Components/ProvidersList';
import NavbarComponent from './Components/NavbarComponent';
import { getCustomPluginData, PluginContext } from './Config/PluginData';
import { isTriggerOnAppLaunch, isHook, goBack } from './Utils';


const storeConnector = connectToStore((state) => { // Store connector entity to obtain screen data
  const values = Object.values(state.rivers);
  const screenData = values.find(
    ({ type }) => type === 'adobe-primetime-auth-qb'
  );
  return { screenData };
});
// Native module that will receive events (login, etc...)
const adobeAccessEnabler = NativeModules.AdobePassContract;
// Native module that will send events to RN
const adobeEventsListener = new NativeEventEmitter(adobeAccessEnabler);


class AdobeComponent extends Component {
  pluginData = getCustomPluginData(this.props.screenData);

  constructor(props) {
    super(props);
    this.state = {
      loading: true,
      dataSource: null
    };
  }

  componentDidMount() {
    const { navigator } = this.props;
    this.setState({ loading: true });
    return isHook(navigator) ? this.loginFlow() : this.logoutFlow();
  }

  logoutFlow = () => {
    const logoutText = R.pathOr('', ['customText', 'logoutDialogMessageText'], this.pluginData);
    const { navigator } = this.props;

    Alert.alert(
      logoutText,
      '',
      [
        { text: 'Cancel', onPress: () => goBack(navigator), style: 'cancel' },
        { text: 'OK', onPress: () => goBack(navigator) },
      ],
      { cancelable: false }
    );
  };

  loginFlow = () => {
    const {
      screenData = {},
      payload = {},
      navigator,
      callback
    } = this.props;

    const { title = '', id = '' } = payload;

    const additionalParams = {
      isTriggerOnAppLaunch: isTriggerOnAppLaunch(navigator),
      itemTitle: title,
      itemID: id
    };

    // set Initialize AccessEnabler
    adobeAccessEnabler.setupAccessEnabler(screenData.general);
    adobeAccessEnabler.startLoginFlow(additionalParams, (error, response) => {
      const { success } = response;
      if (success) {
        callback({
          success,
          payload
        });
      }
    });

    // subscribe on update of mvpds
    adobeEventsListener.addListener(
      'showProvidersList',
      (response) => {
        this.setState({
          loading: false,
          dataSource: response
        });
      }
    );
  };

  setProviderID = (id) => {
    adobeAccessEnabler.setProviderID(id);
  };

  closeHook = () => {
    const { callback, payload } = this.props;
    callback({
      success: false,
      payload
    });
  };

  renderActivityIndicator = () => (
    <View style={styles.loadingContainer}>
      <ActivityIndicator size="large" color="white" />
    </View>
  );

  renderPickerScreen() {
    const { dataSource } = this.state;

    return (
      <PluginContext.Provider value={this.pluginData}>
        <View style={styles.pickerScreenContainer}>
          <NavbarComponent closeHook={this.closeHook} />
          <ProvidersList data={dataSource} setProviderID={this.setProviderID} />
        </View>
      </PluginContext.Provider>
    );
  }

  render() {
    const { loading } = this.state;

    return (
      loading
        ? this.renderActivityIndicator()
        : this.renderPickerScreen()
    );
  }
}

const styles = StyleSheet.create({
  loadingContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center'
  },
  pickerScreenContainer: {
    flex: 1
  }
});

export default storeConnector(AdobeComponent);

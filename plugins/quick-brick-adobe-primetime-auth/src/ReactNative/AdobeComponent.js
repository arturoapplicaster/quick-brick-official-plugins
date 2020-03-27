import React, { Component } from 'react';
import {
  NativeModules,
  StyleSheet,
  ActivityIndicator,
  NativeEventEmitter,
  View,
  Text,
  SafeAreaView
} from 'react-native';
import { ProvidersList } from './Components/ProvidersList.js';
import { connectToStore } from '@applicaster/zapp-react-native-redux';
import { getCustomPluginData, PluginContext } from './Config/PluginData';
import { isTriggerOnAppLaunch } from './Utils';


const storeConnector = connectToStore(state => { //Store connector entity to obtain screen data
    const values = Object.values(state.rivers);
    const screenData = values.find(
        ({ type }) => type === 'adobe-primetime-auth-qb'
    );
    return { screenData }
});
const adobeAccessEnabler = NativeModules.AdobeAccessEnabler; // Native module that will receive events (login, etc...)
const adobeEventsListener = new NativeEventEmitter(adobeAccessEnabler); //Native module that will send events to RN


class AdobeComponent extends Component {
  constructor(props) {
    super(props);
    this.state = {
      loading: true,
      dataSource: null
    }
  }

  pluginData = getCustomPluginData(this.props.screenData);

  startFlow = () => {
    const {
      screenData = {},
      payload = {},
      navigator = {}
    } = this.props;

    const { title = '', id = '' } = payload;

    const additionalParams = {
      isTriggerOnAppLaunch: isTriggerOnAppLaunch(navigator),
      itemTitle: title,
      itemID: id
    };

    //set Initialize AccessEnabler
    adobeAccessEnabler.setupAccessEnabler(screenData.general);
    adobeAccessEnabler.startLoginFlow(additionalParams, function (error, response) {
      console.log(response, 'response from native side');
    });

    //subscribe on update of mvpds
    adobeEventsListener.addListener(
      "showProvidersList",
      (response) => {
        this.setState({
          loading: false,
          dataSource: response
        });
      }
    )
  };

  componentDidMount() {
    this.setState({ loading: true });
    this.startFlow();
  }

  setProviderID = (id) => {
    adobeAccessEnabler.setProviderID(id);
  };

  renderActivityIndicator = (loadingMessage) => {
    return (
      <View style={styles.loadingContainer}>
        <Text style={styles.loadingTitle}>{loadingMessage}</Text>
        <ActivityIndicator style={{ marginTop: 20 }} size='large' color='white'/>
      </View>
    );
  };

  renderPickerScreen() {
    const {
      customStyle: {
        navigationBarBackgroundColor,
        navigationBarTitleColor
      },
      customText: {
        navigationBarTitle
      }
    } = this.pluginData;

    return (
      <PluginContext.Provider value={this.pluginData}>
        <View style={styles.pickerScreenContainer}>
          <View style={{ ...styles.pickerScreenNavigationBar, backgroundColor: navigationBarBackgroundColor }}>
            <Text style={{...styles.pickerNavigationBarTitle, color: navigationBarTitleColor}}>
              {navigationBarTitle}
            </Text>
          </View>
          <ProvidersList data={this.state.dataSource} setProviderID={this.setProviderID} />
        </View>
      </PluginContext.Provider>
    );
  }

  render() {
    return (
      this.state.loading
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
  loadingTitle: {
    alignItems: 'center',
    justifyContent: 'center',
    color: 'white'
  },
  pickerScreenContainer: {
    flex: 1,
    backgroundColor: "white"
  },
  pickerScreenNavigationBar: {
    alignItems: 'center',
    justifyContent: 'center',
    height: 70
  },
  pickerNavigationBarTitle: {
    position: 'absolute',
    bottom: 5
  }
});

export default storeConnector(AdobeComponent);

import React, { Component } from 'react';
import {
    NativeModules,
    StyleSheet,
    TouchableOpacity,
    ActivityIndicator,
    NativeEventEmitter,
    View,
    Text,
    FlatList
} from 'react-native';

import { connectToStore } from '@applicaster/zapp-react-native-redux'
import { ProviderCell } from './ProviderCell/ProviderCell.js'

const storeConnector = connectToStore(state => { //Store connector entity to obtain screen data
    const values = Object.values(state.rivers)
    const screenData = values.find(
        ({ type }) => type === 'adobe-primetime-auth-qb',
    )
    return { screenData }
})

const adobeAccessEnabler = NativeModules.AdobeAccessEnabler // Native module that will receive events (login, etc...)
const adobeEventsListener = new NativeEventEmitter(NativeModules.AdobeAccessEnabler) //Native module that will send events to RN

class AdobeComponent extends Component {

    constructor(props) {
        super(props)
        this.state = {
            loading: true,
            dataSource: null
        }
    }

    componentDidMount() {
        this.setState({ loading: true });
        const isTriggerOnAppLaunch = (navigator) => { 
            return R.pathOr(false, ['payload', 'home'], navigator.routeData());
        };
        const {title, id} = this.props.payload;
        const additionalParams = {
            'isTriggerOnAppLaunch': isTriggerOnAppLaunch == null ? true : false,
            'itemTitle': title,
            'itemID': id
        };

        //set Initialize AccessEnabler
        adobeAccessEnabler.setupAccessEnabler(this.props.screenData.general);
        adobeAccessEnabler.startLoginFlow(additionalParams,function(error, response) {
            console.log(response)
        });

        //subscribe on update of mvpds
        adobeEventsListener.addListener(
            "showProvidersList",
            res => {
                this.setState({ loading: false })
                this.setState({ dataSource: res })
            }
        )
    }

    setProviderID(id) {
        adobeAccessEnabler.setProviderID(id);
    }

    renderActivityIndicator(loadingMessage) {
        return (
            <View style={styles.loadingContainer}>
                <Text style={styles.loadingTitle}>{loadingMessage}</Text>
                <View>
                    <ActivityIndicator style={{ marginTop: 20}}  size="large" color='white' />
                </View>
            </View>
        );
    }

    renderProviderCell = ({ item }) => (
        <TouchableOpacity onPress={() => this.setProviderID(item.id)}> 
            <ProviderCell
                id={item.id}
                title={item.title}
                logoURL={item.logoURL}
            />
        </TouchableOpacity>
    );

    renderPickerScreen(pickerScreenData) {
        const {navigationBarBackgroundColor, navigationBarTitleColor} = pickerScreenData
        return (
            <View style={styles.pickerScreenContainer}>
                <View style={{...styles.pickerScreenNavigationBar, backgroundColor: navigationBarBackgroundColor}}>
                          <Text style={{...styles.pickerNavigationBarTitle, color: navigationBarTitleColor}}>
                                    {pickerScreenData.navigationBarTitle}
                          </Text>
                </View>
                <FlatList
                    data={this.state.dataSource}
                    renderItem={this.renderProviderCell}
                />
            </View>
        );
    }

    render() {
        const {
            general: {
                login_navbar_background_color: navigationBarBackgroundColor,
                login_navbar_title_color: navigationBarTitleColor,
                login_navbar_title: navigationBarTitle,
                login_loading_message: loadingMessage,
            } = {}
        } = this.props.screenData || {};

        const pickerScreenData = {
            navigationBarBackgroundColor,
            navigationBarTitleColor,
            navigationBarTitle
        };

        return (
            this.state.loading ? this.renderActivityIndicator(loadingMessage) :
                                 this.renderPickerScreen(pickerScreenData)
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
    },
    horizontal: {
        flexDirection: 'row',
        justifyContent: 'space-around',
        paddingBottom: 5
    }
})

export default storeConnector(AdobeComponent);

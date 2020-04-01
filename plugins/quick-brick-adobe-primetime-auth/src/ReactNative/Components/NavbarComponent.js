import React, { useContext } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView
} from 'react-native';
import { PluginContext } from '../Config/PluginData';
import CloseButton from './CloseButton';


export default function NavbarComponent({ closeHook }) {
  const {
    customStyle: { headerColor },
    titleTextStyle,
    instructionsTextStyle,
    customText: {
      titleText,
      instructionsText
    }
  } = useContext(PluginContext);

  return (
    <SafeAreaView style={{ backgroundColor: headerColor }}>
      <CloseButton closeHook={closeHook} label="X" />
      <View style={styles.container}>
        <Text
          style={[titleTextStyle, styles.title]}
          numberOfLines={1}
          ellipsizeMode="tail"
        >
          {titleText}
        </Text>
        <Text
          style={[instructionsTextStyle, styles.instructions]}
          numberOfLines={2}
          ellipsizeMode="tail"
        >
          {instructionsText}
        </Text>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'space-around',
    paddingLeft: 40,
    paddingRight: 40,
    height: 123
  },
  title: {
    marginTop: 10,
    fontWeight: 'bold'
  },
  instructions: {
    marginBottom: 20,
    textAlign: 'center'
  }
});

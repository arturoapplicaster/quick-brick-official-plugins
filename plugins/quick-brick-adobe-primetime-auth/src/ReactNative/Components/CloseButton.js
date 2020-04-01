import React from 'react';
import {
  TouchableOpacity,
  Text,
  StyleSheet,
  SafeAreaView,
  Platform
} from 'react-native';


export default function CloseButton({ closeHook, label }) {
  return (
    <SafeAreaView style={styles.button}>
      <TouchableOpacity onPress={() => closeHook()}>
        <Text style={styles.buttonText}>{label}</Text>
      </TouchableOpacity>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  button: {
    position: 'absolute',
    ...Platform.select({
      android: {
        left: 20,
        top: 20,
      },
      ios: {
        left: 30,
        top: 40,
      }
    }),
    zIndex: 1
  },
  buttonText: {
    fontWeight: 'bold',
    fontSize: 28,
    color: 'white'
  }
});

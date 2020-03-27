import React from 'react';
import { TouchableOpacity, Text, StyleSheet, SafeAreaView } from 'react-native';


export default function CloseButton({ closeHook, label }) {
  return (
    <SafeAreaView>
      <TouchableOpacity
        style={styles.button}
        onPress={() => closeHook()}
      >
        <Text style={styles.buttonText}>{label}</Text>
      </TouchableOpacity>
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  button: {
    position: 'absolute',
    left: 30,
    top: 10
  },
  buttonText: {
    fontWeight: 'bold',
    fontSize: 28,
    color: 'white'
  }
});

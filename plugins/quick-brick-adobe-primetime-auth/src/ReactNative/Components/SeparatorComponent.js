import React, { useContext } from 'react';
import { View, StyleSheet } from 'react-native';
import { PluginContext } from '../Config/PluginData';


export default function SeparatorComponent({ highlighted }) {
  const { customStyle: { listSeparatorColor } } = useContext(PluginContext);

  return (
    <View style={[styles.separator, { borderBottomColor: listSeparatorColor }, highlighted && { marginLeft: 0 }]} />
  )
}

const styles = StyleSheet.create({
  separator: {
    borderBottomWidth: 1,
    alignSelf:'stretch'
  }
});


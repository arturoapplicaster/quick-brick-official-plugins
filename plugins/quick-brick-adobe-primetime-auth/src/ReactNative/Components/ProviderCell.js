import React from 'react';
import {
  View,
  Text,
  Image,
  StyleSheet,
  TouchableOpacity
} from 'react-native';


export function ProviderCell(props) {
  const {
    item: {
      id,
      logoURL,
      title
    },
    setProviderID
  } = props;

  return (
    <TouchableOpacity onPress={() => setProviderID(id)}>
      <View style={styles.cellContainer}>
        <Text style={styles.cellTitle}>{title}</Text>
        <Image
          style={styles.cellImage}
          source={{uri: logoURL}}/>
      </View>
    </TouchableOpacity>
  )
}

const styles = StyleSheet.create({
  cellContainer: {
    flex: 1,
    flexDirection: 'row',
    alignItems: "center",
    justifyContent: "space-between",
    height: 50
  },
  cellTitle: {
    textAlign: "left",
    marginLeft: 10
  },
  cellImage: {
    height: 50,
    width: 50,
    marginRight: 10,
    resizeMode: 'center'
  }
});

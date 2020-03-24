import React from 'react';
import {
   View,
   Text,
   Image,
   StyleSheet
} from 'react-native';

export class ProviderCell extends React.PureComponent {
   render() {
      return (
         <View style={styles.cellContainer}>
            <Text style={styles.cellTitle}>{this.props.title}</Text>
            <Image
               style={styles.cellImage}
               source={{ uri: this.props.logoURL }}/>
         </View>
       )
    }
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
})
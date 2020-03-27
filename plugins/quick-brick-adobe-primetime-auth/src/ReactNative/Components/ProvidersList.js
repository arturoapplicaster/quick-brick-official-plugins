import React, { useContext } from 'react';
import {
  FlatList
} from 'react-native';
import { ProviderCell } from './ProviderCell';
import SeparatorComponent from './SeparatorComponent';
import { PluginContext } from '../Config/PluginData';

export function ProvidersList({ data, setProviderID }) {
  const {
    customStyle: {
      listBackgroundColor
    }
  } = useContext(PluginContext);

  return (
    <FlatList
      ItemSeparatorComponent={({highlighted}) => (
        <SeparatorComponent highlighted={highlighted} />
        )}
      data={data}
      renderItem={({ item }) => (
        <ProviderCell item={item} setProviderID={setProviderID}/>
      )}
      keyExtractor={item => item.id}
      style={{ backgroundColor: listBackgroundColor }}
      ListFooterComponent={() => (
        <SeparatorComponent />
      )}
    />
  )
}

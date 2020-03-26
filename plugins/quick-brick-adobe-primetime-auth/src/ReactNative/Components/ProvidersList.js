import React from 'react';
import {
  FlatList
} from 'react-native';
import { ProviderCell } from './ProviderCell';

export function ProvidersList({ data, setProviderID }) {
  return (
    <FlatList
      data={data}
      renderItem={({ item }) => (
        <ProviderCell item={item} setProviderID={setProviderID}/>
      )}
      keyExtractor={item => item.id}
    />
  )
}

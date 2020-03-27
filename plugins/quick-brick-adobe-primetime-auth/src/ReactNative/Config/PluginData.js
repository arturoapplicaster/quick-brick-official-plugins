import React from 'react';
import { getPluginData } from '../Utils';

export function getCustomPluginData(screenData) {
  const {
    login_navbar_background_color: navigationBarBackgroundColor,
    login_navbar_title_color: navigationBarTitleColor,
    login_navbar_title: navigationBarTitle,
    header_color: headerColor,
    list_background_color: listBackgroundColor,
    list_separator_color: listSeparatorColor,
    title_text: titleText,
    title_text_fontsize: titleTextFontsize,
    title_text_color: titleTextColor,
    instructions_text: instructionsText,
    instructions_text_fontsize: instructionsTextFontsize,
    instructions_text_color: instructionsTextColor,
    list_item_fontsize: listItemFontsize,
    list_item_color: listItemColor,
    logout_dialog_message_text: logoutDialogMessageText,
    base_url: baseUrl,
    software_statement: softwareStatement,
    requestor_id: requestorId,
    resource_id: resourceId,
    url_scheme: urlScheme,
    deep_link: deepLink
  } = getPluginData(screenData);

  const titleTextStyle = {
    color: titleTextColor,
    fontSize: titleTextFontsize
  };

  const instructionsTextStyle = {
    color: instructionsTextColor,
    fontSize: instructionsTextFontsize
  };

  const listItemStyle = {
    color: listItemColor,
    fontSize: listItemFontsize
  };

  const customText = {
    navigationBarTitle,
    titleText,
    instructionsText,
    logoutDialogMessageText
  };

  const customStyle = {
    navigationBarBackgroundColor,
    navigationBarTitleColor,
    headerColor,
    listBackgroundColor,
    listSeparatorColor
  };

  const authConfig = {
    baseUrl,
    softwareStatement,
    requestorId,
    resourceId,
    urlScheme,
    deepLink
  };

  return {
    titleTextStyle,
    instructionsTextStyle,
    listItemStyle,
    customText,
    customStyle,
    authConfig
  };
}

export const PluginContext = React.createContext();

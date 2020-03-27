import * as R from "ramda";

const isTriggerOnAppLaunch = (navigator) => {
  return R.pathOr(false, ['payload', 'home'], navigator.routeData());
};

function getPluginData(screenData) {
  let pluginData = {};

  if (screenData && screenData.general) {
    pluginData = { ...pluginData, ...screenData.general };
  }

  return pluginData;
}

export {
  isTriggerOnAppLaunch,
  getPluginData
}

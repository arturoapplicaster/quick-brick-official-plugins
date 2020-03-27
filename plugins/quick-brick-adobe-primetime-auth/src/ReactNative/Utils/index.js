import * as R from "ramda";

const defaultFontSize = 20;

const isTriggerOnAppLaunch = (navigator) => {
  return R.pathOr(false, ['payload', 'home'], navigator.routeData());
};

function getPluginData(screenData) {
  let pluginData = {};

  if (screenData && screenData.general) {
    pluginData = { ...pluginData, ...screenData.general };
    validateStyles(pluginData);
  }

  return pluginData;
}

function validateStyles(pluginData) {
  const keys = Object.keys(pluginData);
  keys.forEach((key) => {
    const type = key.split('_').pop();
    if (type === 'fontsize') {
      validateFontsize(key, pluginData);
    }
  });
}

const validateFontsize = (key, pluginData) => {
  const value = pluginData[key];
  const keyname = R.replace('_fontsize', '', key);

  const num = Number(value);
  pluginData[key] = Number.isFinite(num) ? num : defaultFontSize;
};

export {
  isTriggerOnAppLaunch,
  getPluginData
}

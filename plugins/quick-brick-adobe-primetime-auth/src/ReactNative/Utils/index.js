import * as R from "ramda";

const isTriggerOnAppLaunch = (navigator) => {
  return R.pathOr(false, ['payload', 'home'], navigator.routeData());
};

export {
  isTriggerOnAppLaunch
}

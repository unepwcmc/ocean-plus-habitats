import axios from 'axios'

export const getCountryExtentByISO3 = (iso3, cb) => {
  axios.get(`https://services5.arcgis.com/Mj0hjvkNtV7NRhA7/ArcGIS/rest/services/WVS_EEZv8/FeatureServer/0/query?where=ISO3='${iso3}'+AND+type='Land'&returnGeometry=true&returnExtentOnly=true&f=pjson`).then(cb)
}
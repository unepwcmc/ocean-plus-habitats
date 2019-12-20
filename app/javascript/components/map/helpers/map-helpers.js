export const getSubLayerId = (layer, layerType) => layer.id + '-' + layerType

export const getSubLayerIds = layer =>
  ['poly', 'point'].map(layerType => getSubLayerId(layer, layerType))

export const getSubLayers = (config, isSelected) => {
  const layers = []
  const layer = {
    ...config,
    visible: isSelected
  }

  Object.keys(layer.sourceLayers).forEach(layerType => {
    layers.push({
      ...layer,
      type: layerType,
      sourceLayer: layer.sourceLayers[layerType],
      id: getSubLayerId(layer, layerType)
    })
  })

  return layers
}

export const getFirstForegroundLayerId = map => {
  let firstBoundaryId = ''
  let firstSymbolId = ''

  for (const layer of map.getStyle().layers) {
    if (layer.id.match('admin') && layer.id.match('boundaries')) {
      firstBoundaryId = layer.id
      break
    } else if (layer.type === 'symbol') {
      firstSymbolId = layer.id
    }
  }

  return firstBoundaryId || firstSymbolId
}
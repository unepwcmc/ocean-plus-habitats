// data-layer is used to distinguish these from base map layers
export const getSubLayerId = (layer, layerType) => 'data-layer' + '-' + layer.id + '-' + layerType

export const getSubLayerIds = layer =>
  ['poly', 'point', 'line', 'no-data', '0-20', '21-40', '41-60', '61-80', '81-100'].map(layerType => getSubLayerId(layer, layerType))

export const getSubLayers = (config, isSelected) => {
  const layers = []
  const layer = {
    ...config,
    visible: isSelected
  }

  layer.sourceLayers.forEach(layerType => {
    const subName = layerType.sub_name || layerType.type

    layers.push({
      ...layer,
      color: layerType.color || layer.color,
      type: layerType.type,
      sourceLayer: layerType.name,
      filter_id: layerType.filter_id,
      id: getSubLayerId(layer, subName)
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

export const getFirstDataLayerId = map => {
  let id = ''
  
  for (const layer of map.getStyle().layers) {
    if (layer.id.match('data-layer')) {
      id = layer.id
      break
    }
  }

  return id
}
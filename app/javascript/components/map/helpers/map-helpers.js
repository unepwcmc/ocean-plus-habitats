export const getLayers = (config, isSelected) => {
  const layers = []
  const layer = {
    ...config,
    visible: isSelected
  }

  layers.push(layer) //TODO: handle multiple layers per dataset

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
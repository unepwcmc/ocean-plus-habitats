import { getFirstDataLayerId } from '../helpers/map-helpers'

const addImagePaintOptions = (map, options, layer) => {
  addFillPaintOptions(options, layer)
  const patternId = 'pattern' + layer.id

  options['paint']['fill-pattern'] = patternId

  map.loadImage(
    layer.image,
    (err, image) => {
      if (err) { throw err }
      
      map.addImage(patternId, image)
    }
  )
}

const addFillPaintOptions = (options, layer) => {
  options['type'] = 'fill'
  options['paint'] = {
    'fill-color': layer.color,
    'fill-outline-color': 'transparent',
    'fill-opacity': getOpacity(layer.opacity),
  }
}

const addCirclePaintOptions = (options, layer) => {
  options['type'] = 'circle'
  options['paint'] = { 
    'circle-radius': [
      'interpolate',
      ['exponential', 1],
      ['zoom'],
      0, 1,
      6, 3
    ],
    'circle-color': layer.color,
    'circle-opacity': getOpacity(layer.opacity)
  }
}
const addLinePaintOptions = (options, layer) => {
  options['type'] = 'line'
  options['paint'] = {
    'line-color': layer.color,
    'line-opacity': getOpacity(layer.opacity),
    'line-width': [
      'interpolate',
      ['exponential', 0.8],
      ['zoom'],
      0, 4,
      8, 0
    ]
  } 
}

const getOpacity = opacity => opacity || 1

export default {
  methods: {
    addVectorTileLayer (layer) {            
      const options = {
        'id': layer.id,
        'source': {
          'type': 'vector',
          'tiles': [layer.tilesUrl]
        },
        'source-layer': layer.sourceLayer,
        'filter': layer.filter_id ? ['==', '_symbol', layer.filter_id] : ['all']
      }

      if (layer.type === 'point') {
        addCirclePaintOptions(options, layer)
      } else if (layer.type === 'line') {
        addLinePaintOptions(options, layer)
      } else if (layer.image) {
        addImagePaintOptions(this.map, options, layer)
      } else {
        addFillPaintOptions(options, layer)
      }

      const nextLayer = layer.addUnderneath ? getFirstDataLayerId(this.map) : this.firstForegroundLayerId

      this.map.addLayer(options, nextLayer)
    }
  }
}

import { getFirstDataLayerId } from '../helpers/map-helpers'

const addImageLayer = (map, options, layer, nextLayer) => {
  map.loadImage(
    layer.image,
    (err, image) => {
      if (err) { 
        console.warn(`Image ${layer.image} not found. Falling back to solid fill.`)

        delete options['paint']['fill-pattern']

        map.addLayer(options, nextLayer)
      } else {
        map.addImage(getPatternId(layer), image)
        map.addLayer(options, nextLayer)
      }
    }
  )
}

const addImagePaintOptions = (options, layer) => {
  addFillPaintOptions(options, layer)

  options['paint']['fill-pattern'] = getPatternId(layer)
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

const getPatternId = layer => 'pattern' + layer.id

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
        addImagePaintOptions(options, layer)
      } else {
        addFillPaintOptions(options, layer)
      }

      const nextLayer = layer.addUnderneath ? getFirstDataLayerId(this.map) : this.firstForegroundLayerId

      if (layer.image) {
        // Need to wait until image is loaded in case falling back to solid fill
        addImageLayer(this.map, options, layer, nextLayer)
      } else {
        this.map.addLayer(options, nextLayer)
      }
    }
  }
}

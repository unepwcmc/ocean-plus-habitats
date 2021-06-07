import { getFirstDataLayerId } from '../helpers/map-helpers'

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
        }
      } else if (layer.type === 'line') {
        options['type'] = 'line'
        options['paint'] = {
          'line-color': layer.color,
          'line-opacity': layer.opacity || 1,
          'line-width': [
            'interpolate',
            ['exponential', 0.8],
            ['zoom'],
            0, 4,
            8, 0
          ]
        } 
      } else {
        options['type'] = 'fill'
        options['paint'] = {
          'fill-color': layer.color,
          'fill-outline-color': 'transparent',
          'fill-opacity': layer.opacity || 1,
        }
      }

      const nextLayer = layer.addUnderneath ? getFirstDataLayerId(this.map) : this.firstForegroundLayerId

      this.map.addLayer(options, nextLayer)
    }
  }
}

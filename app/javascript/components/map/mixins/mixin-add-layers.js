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
          'circle-radius': 2,
          'circle-color': layer.color,
        }
      } else {
        options['type'] = 'fill'
        options['paint'] = {
          'fill-color': layer.color,
          'fill-outline-color': 'transparent'
        }
      }

      console.log(options)

      this.map.addLayer(options, this.firstTopLayerId)
    }
  }
}

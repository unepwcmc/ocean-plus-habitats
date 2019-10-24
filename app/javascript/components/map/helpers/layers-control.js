export default class LayersControl {
  onAdd(map) {
    this._map = map
    this._container = document.createElement('div')
    this._container.className = 'mapboxgl-ctrl-group mapboxgl-ctrl'

    this._button = document.createElement('button')
    this._button.className = 'mapbox-gl-layer-ctrl-btn'

    this._button.onclick = () => {
      document.getElementsByClassName('mapbox-gl-layer-ctrl-layers')[0].classList.toggle('active')
    }

    this._layers = document.createElement('div')
    this._layers.className = 'mapbox-gl-layer-ctrl-layers'

    const styles = ['basic', 'streets', 'outdoors', 'bright', 'light', 'dark', 'satellite-streets']

    styles.forEach((style) => {
      let s = document.createElement('input')

      s.id = style
      s.type = 'radio'
      s.name = 'style-toggle'
      s.value = style

      s.onclick = () => {
        this._map.setStyle('mapbox://styles/mapbox/' + style + '-v9')
      }

      let l = document.createElement('label')

      l.htmlFor = style
      l.innerText = style

      this._layers.appendChild(s)
      this._layers.appendChild(l)
    })

    this._container.appendChild(this._button)
    this._container.appendChild(this._layers)

    return this._container
  }

  onRemove() {
    this._container.parentNode.removeChild(this._container)
    this._map = undefined
  }
}
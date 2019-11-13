const ESCAPE_KEYCODE = 27

export default ({closeCallback, toggleVariable='isActive', closeOnClickOutside=true, closeOnEscKeypress=true}) => ({
  mounted () {
    if(closeOnClickOutside) {
      window.addEventListener('click', this.clickOutsideHandler)
    }

    if(closeOnEscKeypress) {
      this.$el.addEventListener('keydown', this.escKeypressHandler)
    }
  },

  methods: {
    clickOutsideHandler (e) {
      if (this[toggleVariable] && !this.$el.contains(e.target)) { this[closeCallback](e) }
    },

    escKeypressHandler (e) {
      if (e.keyCode === ESCAPE_KEYCODE) { 
        if(this[toggleVariable]) {
          this[closeCallback](e)
          e.stopPropagation()
        }
      }
    }
  },

  beforeDestroy() {
    window.removeEventListener('click', this.clickOutsideHandler)
    window.removeEventListener('keydown', this.escKeypressHandler)
  }
})
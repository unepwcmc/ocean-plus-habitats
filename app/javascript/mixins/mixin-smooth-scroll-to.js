import smoothscroll from 'smoothscroll-polyfill'

smoothscroll.polyfill()

export default {
  mounted () {
    this.setTriggerOffset()
  },

  computed: {
    supportsNativeSmoothScroll() {
      return 'scrollBehavior' in document.documentElement.style
    }
  },

  methods: {
    backToTop () {
      this.animate(0)
    },

    // scroll down to the section of the page which corresponds to the
    // link that has been clicked
    scroll (id) {
      const offset = document.getElementById('section-' + id).offsetTop,
        top = offset - this.triggerOffset

      this.animate(top)
    },

    animate (top) {
      if(this.supportsNativeSmoothScroll) {
        window.scrollTo({ top: top, behavior: 'smooth' })
      } else {
        window.scroll({ top: top, left: 0, behavior: 'smooth' })
      }
    },

    setTriggerOffset () {
      // this offset accounts for the sticky bars at the top of the window
      this.triggerOffset = document.querySelector('.sm-target-sticky').clientHeight
    },
    
    windowResized () {
      // when the window width is resized the heights of the sticky bars and
      // years will change so update js accordingly
      const newWidth = window.innerWidth

      if(newWidth > this.windowWidth || newWidth < this.windowWidth) {
        this.setTriggerOffset()
        this.updateScrollMagicDurations()
        this.currentEvent()
        this.$eventHub.$emit('getScrollY')

        this.windowWidth = newWidth
      }
    }
  }
}
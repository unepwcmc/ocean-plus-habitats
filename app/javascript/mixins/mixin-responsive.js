import { debounce } from 'lodash'

const BREAKPOINT_SM_ID = 'small'
const BREAKPOINT_MD_ID = 'medium'
const BREAKPOINT_LG_ID = 'large'

export const mixinResponsive = {
  data () {
    return {
      windowWidth: 0,
      currentBreakpoint: '',
      breakpoints: {
        [BREAKPOINT_SM_ID]: 720,
        [BREAKPOINT_MD_ID]: 960,
      }
    }
  },

  created () {
    this.updateWindowSize()

    // allow for multiple functions to be called on window resize
    window.addEventListener('resize', this.onWindowResize)

    this.$root.$on('windowResized', this.updateWindowSize)
  },

  beforeDestroy () {
    window.removeEventListener('resize', this.onWindowResize)
  },

  methods: {
    onWindowResize: debounce(function () {
      this.$root.$emit('windowResized')
    }, 100),

    updateWindowSize () {
      this.windowWidth = window.innerWidth

      if (this.isSmall()) {
        this.currentBreakpoint = BREAKPOINT_SM_ID
      } else if (this.isMedium()) {
        this.currentBreakpoint = BREAKPOINT_MD_ID
      } else if (this.isLarge()) {
        this.currentBreakpoint = BREAKPOINT_LG_ID
      }
    },

    isSmall () {
      return this.windowWidth <= this.breakpoints[BREAKPOINT_SM_ID]
    },

    isMedium () {
      return this.windowWidth > this.breakpoints[BREAKPOINT_SM_ID] && this.windowWidth <= this.breakpoints[BREAKPOINT_MD_ID]
    },

    isLarge () {
      return this.windowWidth > this.breakpoints[BREAKPOINT_MD_ID]
    },

    getCurrentBreakpoint () {
      return this.currentBreakpoint
    }
  }
}

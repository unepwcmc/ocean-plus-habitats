<template>
  <button 
    class="scroll-to-top"
    @click="scrollToTop"
  />
</template>

<script>
export default {
  data () {
    return {
      increment: 20,
      start: 0,
      currentTime: 0,
      duration: 0
    }
  },

  methods: {
    scrollToTop () {
      this.setParams()
      this.animateScroll()
    },

    setParams () {
      this.start = window.pageYOffset || document.documentElement.scrollTop,
      this.duration = 20 * Math.sqrt(this.start)
      this.currentTime = 0
    },

    animateScroll () {
      this.currentTime += this.increment
      const scrollTop = this.easeInOutQuad(this.currentTime, this.start, -this.start, this.duration)
      
      window.scrollTo(0, scrollTop)
      if (this.currentTime < this.duration) {
        setTimeout(this.animateScroll, this.increment)
      }
    },

    // t = current time, b = start value, c = change in value, d = duration
    easeInOutQuad (t, b, c, d) {
      t /= d / 2
      if (t < 1) { return c / 2 * t * t + b }
      t--

      return -c / 2 * (t * (t - 2) - 1) + b
    }
  }
}
</script>
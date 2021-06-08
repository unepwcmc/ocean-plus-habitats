<template>
  <button 
    class="scroll-to-top"
    @click="scrollToTop"
  />
</template>

<script>
import mixinSmoothScrollTo from '../../mixins/mixin-smooth-scroll-to'

export default {
  name: 'ScrollToTop',

  mixins: [ mixinSmoothScrollTo ],

  methods: {
    scrollToTop () {
      this.backToTop()
    }
  }
}
</script>
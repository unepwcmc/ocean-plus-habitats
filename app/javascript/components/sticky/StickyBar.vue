<template>
  <div class="sticky-bar">
    <slot></slot>
  </div>  
</template>

<script>
  import ScrollMagic from 'scrollmagic'

  export default {
    name: 'sticky-bar',

    mounted () {
      this.scrollMagicHandlers()
    },

    methods: {
      scrollMagicHandlers () {
        let scrollMagicSticky = new ScrollMagic.Controller()

        new ScrollMagic.Scene({ triggerElement: '.sm-trigger-sticky', reverse: true })
          .triggerHook('onLeave')
          .setClassToggle('.sm-target-sticky', 'sticky')
          .addTo(scrollMagicSticky)
      }
    }
  }
</script>
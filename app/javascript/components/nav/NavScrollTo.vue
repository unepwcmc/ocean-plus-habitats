<template>
  <nav>
    <nav-link-scroll
      v-for="(link, index) in nav" 
      :key="getVForKey(index)"
      :id="link.id"
      :title="link.title"
      v-on:click="scroll"
    />
  </nav>  
</template>

<script>
import mixinId from '../../mixins/mixin-ids'
import mixinSmoothScrollTo from '../../mixins/mixin-smooth-scroll-to'
import NavLinkScroll from './NavLinkScroll.vue'

export default {
  name: 'nav-scroll-to',

  mixins: [ mixinId, mixinSmoothScrollTo ],

  components: { NavLinkScroll },

  props: {
    nav: {
      type: Array,
      required: true
    }
  }
}
</script>
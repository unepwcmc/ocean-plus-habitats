<template>
  <nav>
    <nav-link-scroll
      v-for="(link, index) in nav" 
      :id="link.id"
      :key="getVForKey(index)"
      :title="link.title"
      @click="scroll"
    />
  </nav>  
</template>

<script>
import mixinId from '../../mixins/mixin-ids'
import mixinSmoothScrollTo from '../../mixins/mixin-smooth-scroll-to'
import NavLinkScroll from './NavLinkScroll.vue'

export default {
  name: 'NavScrollTo',

  components: { NavLinkScroll },

  mixins: [ mixinId, mixinSmoothScrollTo ],

  props: {
    nav: {
      type: Array,
      required: true
    }
  }
}
</script>
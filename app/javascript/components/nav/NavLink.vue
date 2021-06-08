<template>
  <a 
    :href="link.url"
    :class="['nav__a', { 'active': isActive }]"
    :title='`Go to page: ${link.title}`'
  >
    {{ link.title }}  
  </a>  
</template>

<script>
export default {
  name: 'NavLink',

  props: {
    link: {
      type: Object,
      required: true
    }
  },

  data () {
    return {
      isActive: false
    }
  },

  methods: {
    triggerNavItem () {
      this.$eventHub.$emit('changeHabitat', this.name)
    }
  }
}
</script>
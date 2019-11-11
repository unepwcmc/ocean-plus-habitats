<template>
  <p
    class="nav__a no-margin"
    :class="[{ 'active': isActive }, theme]"
    @click="triggerNavItem"
  >
    {{ title }}  
  </p>  
</template>

<script>
export default {
  name: 'NavLink',

  props: {
    title: {
      type: String,
      required: true
    },
    name: {
      type: String,
      required: true
    },
    theme: {
      type: String,
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
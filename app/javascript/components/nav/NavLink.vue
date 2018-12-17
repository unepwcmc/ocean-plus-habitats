<template>
  <p class="nav__a no-margin" :class="{ 'active': isActive }" @click="triggerNavItem">
    {{ title }}  
  </p>  
</template>

<script>
  import { eventHub } from '../../packs/application.js'

  export default {
    name: 'nav-link',

    props: {
      title: {
        type: String,
        required: true
      },
      name: {
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
      triggerNavItem (selectedName) {
        eventHub.$emit('changeHabitat', this.name)
      }
    }
  }
</script>
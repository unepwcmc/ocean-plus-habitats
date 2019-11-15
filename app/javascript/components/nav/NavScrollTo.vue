<template>
  <nav class="nav">
    <nav-link-scroll
      v-for="(navLink, index) in nav" 
      :key="getId(index)"
      :title="navLink.title" 
      :name="navLink.name"
      :theme="navLink.theme"
    />
  </nav>  
</template>

<script>
import NavLinkScroll from './NavLinkScroll.vue'

export default {
  name: 'nav-scroll-to',

  components: { NavLinkScroll },

  props: {
    nav: {
      type: Array,
      required: true
    }
  },

  data () {
    return {
      children: []
    }
  },

  watch: {
    children () {
      if(this.children.length > 0) { this.updateNav(this.default) }
    }
  },

  created () {
    this.children = this.$children
      
    this.$eventHub.$on('changeHabitat', this.updateNav)
  },

  methods: {
    updateNav (selectedName) {
      window.location.replace(`#${selectedName}`)

      let match = 0

      this.children.forEach(child => {
        if(child.name === selectedName) {
          child.isActive = true
          match+= 1           
        } else {
          child.isActive = false
        }
      })
        
      if(match == 0) { 
        this.children[0].isActive = true 
        window.location.replace(`#${this.children[0].name}`)
      }
    },

    getId (index) {
      return `nav-link-${this.id}-${index}`
    }
  }
}
</script>
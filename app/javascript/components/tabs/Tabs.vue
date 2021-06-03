<template>
  <div>
    <ul class="tab__triggers ul-inline ul-unstyled">
      <li 
        v-for="(child, index) in children" 
        :key="getId(index)"
        class="tab__trigger" 
        :class="{ 'active': child.isActive }" 
        @click="triggerTab(child.id)"
      >
        {{ child.title }}
      </li>
    </ul>
    
    <slot />
  </div>  
</template>

<script>
export default {
  name: 'Tabs',

  data () {
    return {
      children: []
    }
  },

  watch: {
    children () {
      if(this.children.length > 0) { this.triggerTab(this.children[0].id) }
    }
  },

  created () {
    this.children = this.$children
      
  },

  methods: {
    triggerTab (selectedId) {
      this.children.forEach(child => {
        child.isActive = child.id === selectedId
      })
    },

    getId (index) {
      return `tab-${this.id}-${index}`
    }
  }
}
</script>
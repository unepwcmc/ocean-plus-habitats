<template>
  <div>
    <ul class="tabs__triggers ul-inline ul-unstyled">
      <li v-for="child, index in children" @click="triggerTab(child.id)" class="tab__trigger" :class="{ 'tab-active': child.isActive }">
        {{ child.title }}
      </li>
    </ul>
    
    <slot></slot>
  </div>  
</template>

<script>
  import { eventHub } from '../../packs/application.js'

  export default {
    name: 'tabs',

    data () {
      return {
        children: []
      }
    },

    created () {
      this.children = this.$children
    },

    mounted () {
      this.triggerTab(this.children[0].id)
    },

    methods: {
      triggerTab (selectedId) {
        this.children.forEach(child => {
          child.isActive = child.id === selectedId
        })
      }
    }
  }
</script>
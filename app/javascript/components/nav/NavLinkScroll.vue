<template>
  <span 
    class="nav__link" 
    @click="click"
    v-html="title"
  />
</template>

<script>
export default {
  name: 'nav-link-scroll',

  props: {
    id: {
      required: true,
      type: String
    },
    title: {
      required: true,
      type: String
    }
  },

  methods: {
    click () {
      this.$emit('click', this.id)
    }
  }
}
</script>

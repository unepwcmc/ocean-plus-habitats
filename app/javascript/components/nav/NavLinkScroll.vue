<template>
  <div :id="id" class="nav__link flex flex-v-center" @click="click">
    <span role="menuitem" class="nav__button"></span>
    <span class="nav__label">{{ item.label }}</span>
  </div>
</template>

<script>
export default {
  name: 'name-link-scroll',

  props: {
    item: {
      required: true,
      type: Object
    }
  },

  computed: {
    id () { return `scroll-link-${this.item.id}` }
  },

  methods: {
    click () {
      this.$emit('click', this.item.id)
    }
  }
}
</script>

<template>
  <modal-base :id="id">
    <div v-html="content" />
  </modal-base>
</template>

<script>
import ModalBase from './ModalBase'

export default {
  name: 'Modal',

  components: { ModalBase },

  props: {
    id: {
      type: String,
      required: true
    }
  },

  computed: {
    content () {
      return this.$store.state.modal.content
    }
  }
}
</script>

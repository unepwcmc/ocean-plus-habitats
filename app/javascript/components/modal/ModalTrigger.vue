<template>
  <button
    :id="triggerId"
    class="modal__trigger"
    aria-haspopup="dialog"
    @click="openModal"><slot></slot></button>
</template>

<script>
export default {
  name: 'modal-trigger',

  props: {
    id: {
      type: String,
      required: true
    },
    modalContent: {
      type: Object
    }
  },

  computed: {
    triggerId () {
      return 'modal-trigger-' + this.id
    }
  },

  methods: {
    openModal () {
      this.$store.dispatch('modal/openModal', this.modalContent)
    }
  }
}
</script>

<template>
  <button
    :id="triggerId"
    class="modal__trigger"
    aria-haspopup="dialog"
    @click="openModal"
  >
    <slot />
    <span
      v-if="tooltipText"
      class="modal__tooltip"
    >
      {{ tooltipText }}
    </span>
  </button>
</template>

<script>
export default {
  name: 'ModalTrigger',

  props: {
    id: {
      type: String,
      required: true
    },
    modalContent: {
      type: String,
      default: null
    },
    tooltipText: {
      type: String,
      default: null
    }
  },

  computed: {
    triggerId () {
      return 'modal-trigger-' + this.id
    }
  },

  methods: {
    openModal () {
      this.$store.dispatch('modal/openModal', { id: this.triggerId, content: this.modalContent })
    }
  }
}
</script>

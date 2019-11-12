<template>
  <div
    class="modal"
    :class="{ 'modal--active' : isActive }"
    @click.self="closeModal"
  >
    <div
      role="dialog"
      aria-modal="true"
      class="modal__dialog"
    >
      <div class="modal__content">
        <button
          class="modal__close"
          @click="closeModal"
        />
          
        <h3 class="modal__title">{{ content.title }}</h3>
        
        <div>
          <p
            v-for="(p, index) in content.text"
            :key="getVForKey('modal', index)"
            v-html="p"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import mixinIds from '../../mixins/mixin-ids'
import mixinFocusCapture from '../../mixins/mixin-focus-capture'
import mixinPopupCloseListeners from '../../mixins/mixin-popup-close-listeners'

export default {
  name: 'Modal',

  mixins: [
    mixinIds,
    mixinFocusCapture({toggleVariable: 'isActive', closeCallback: 'closeModal'}), 
    mixinPopupCloseListeners({closeCallback: 'closeModal', closeOnClickOutside: false})
  ],

  props: {
    id: {
      type: String,
      required: true
    }
  },

  computed: {
    isActive () {
      return this.$store.state.modal.isActive && this.$store.state.modal.id === this.mixinTriggerId
    },

    mixinTriggerId () {
      return 'modal-trigger-' + this.id
    },

    content () {
      return this.$store.state.modal.content
    }
  },

  methods: {
    toggleModal () {
      this.$store.dispatch('modal/closeModal')
    },

    closeModal () {
      this.toggleModal()
    }
  }
}
</script>
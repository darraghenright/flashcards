<script>
import { defineComponent } from "vue";

export default defineComponent({
  created() {
    fetch("flashcards.json")
      .then((response) => response.json())
      .then((cards) => (this.cards = cards))
      .then(() => this.pickQuestion());
  },
  data() {
    return {
      answer: "",
      cards: [],
      lang: "fr",
      question: null,
    };
  },
  methods: {
    pickQuestion() {
      this.answer = "";
      this.question = this.cards[Math.floor(Math.random() * this.cards.length)];
    },
  },
  watch: {
    answer(answer) {
      let answerLang = this.lang === "fr" ? "en" : "fr";

      if (answer == this.question[answerLang]) {
        this.pickQuestion();
      }
    },
    lang() {
      this.pickQuestion();
      this.$refs["answer"].focus();
    },
  },
});
</script>

<template>
  <main class="grid h-screen place-items-center text-center">
    <div v-if="question">
      <div class="text-4xl mb-8">{{ question[lang] }}</div>
      <input
        autofocus
        class="border p-2"
        type="text"
        v-model.trim="answer"
        ref="answer"
      />
      <div class="text-center mt-8">
        <label class="mr-2" for="lang-en">
          <input id="lang-en" type="radio" v-model="lang" value="en" /> EN
        </label>
        <label class="ml-2" for="lang-fr">
          <input id="lang-fr" type="radio" v-model="lang" value="fr" /> FR
        </label>
      </div>
    </div>
  </main>
</template>

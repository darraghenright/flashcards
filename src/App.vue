<script>
import { defineComponent } from "vue";

export default defineComponent({
  computed: {
    answerLang: ({ lang }) => (lang === "fr" ? "en" : "fr"),
  },
  created() {
    fetch("flashcards.json")
      .then((response) => response.json())
      .then((cards) => (this.cards = cards))
      .then(() => this.pickCard());
  },
  data() {
    return {
      answer: "",
      cards: [],
      lang: "en",
      question: null,
      score: {
        yes: 0,
        no: 0,
      },
    };
  },
  methods: {
    checkAnswer() {
      let correctAnswer = this.question[this.answerLang].toLocaleLowerCase();
      let guess = this.answer.toLocaleLowerCase();

      if (guess === correctAnswer) {
        this.score.yes += 1;
        this.pickCard();
      }
    },
    showAnswer() {
      this.answer = this.question[this.answerLang];
      this.score.no += 1;
      setTimeout(() => this.pickCard(), 2_000);
    },
    speakAnswer() {
      let utterance = new SpeechSynthesisUtterance(this.question["fr"]);
      utterance.lang = "fr-FR";
      //utterance.pitch = 0.9;
      speechSynthesis.speak(utterance);
    },
    pickCard() {
      this.answer = "";
      this.question = this.cards[Math.floor(Math.random() * this.cards.length)];
    },
  },
  watch: {
    lang() {
      this.pickCard();
      this.$refs["answer"].focus();
    },
  },
});
</script>

<template>
  <main class="grid h-screen place-items-center text-center">
    <div v-if="question">
      <div class="text-4xl mb-6">{{ question[lang] }}</div>
      <div class="mb-3">
        <span class="text-red-500 text-lg inline-block mr-3">
          {{ score.no }}
        </span>
        <input autofocus class="border p-2 rounded" ref="answer" tabindex="0" type="text" v-model.trim="answer"
          v-on:keyup.esc.exact="showAnswer" v-on:keyup.enter.exact="checkAnswer" v-on:keyup.shift.enter="speakAnswer" />
        <span class="text-green-500 text-lg inline-block ml-3">
          {{ score.yes }}
        </span>
      </div>
      <p class="text-xs text-gray-400 font-light mb-6">
        Type answer and press ENTER, or ESC to skip.
      </p>
      <div class="text-center">
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

<template>
<v-container>
  <v-layout row wrap fill-height justify-center>
    <v-flex
      align="center"
      xs12
    >
      <v-publication-list :publications="publications" title="Publications" />
    </v-flex>
  </v-layout>
</v-container>
</template>

<script>
import publicationView from '@/views/about/components/publication.vue'
export default {
  components: {
    'v-publication-list': publicationView
  },
  data () {
    return {
      publications: [{
        title: "test title 124sajhfjksadh asdfjh aksdfhksdahf sajfhjskh",
        journal: "Custom Journalsfsdfsd",
        year: "2020",
        date: "Nov 23",
        volume: "223-22",
        issue: "12",
        pages: "22",
        PMID: "35534123",
        DOI: "10.1016/S314A4324",
        author: "Li Jianfeng",
        url: "https://baidu.com"
      }]
    }
  }
}
</script>

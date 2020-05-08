<template>
  <v-card>
    <v-data-table
    :headers="headers"
    :items="papers"
    :items-per-page="100"
    :single-expand="singleExpand"
    :expanded.sync="expanded" 
    item-key="Id"
    loading loading-text="Loading... Please wait"
    multi-sort
    show-expand
    class="elevation-1"
    >
      <template v-slot:top>
        <v-toolbar flat>
          <v-toolbar-title>COVID-19 Connections</v-toolbar-title>
          <v-switch v-model="singleExpand" label="Single expand" class="mt-2"></v-switch>
          <v-spacer></v-spacer>
          <v-text-field
            v-model="search"
            append-icon="mdi-magnify"
            label="Search"
            single-line
            hide-details
          ></v-text-field>
        </v-toolbar>
      </template>
      <template v-slot:expanded-item="{ headers, item }">
        <td :colspan="headers.length">Abstract: {{ item.Abs }}</td>
      </template>
    </v-data-table>
  </v-card>
</template>

<script>
  export default {
    name: 'Home',
    data () {
      return {
        search: '',
        expand: [],
        singleExpand: 'false',
        headers: [
          { text: 'Id', value: 'Id', sortable: false },
           { text: 'Title', value: 'Title' },
          { text: 'Pmid', value: 'Pmid' },
          { text: 'Doi', value: 'Doi' },
          { text: 'Journal', value: 'Journal' },
          { text: 'Date', value: 'Date' },
          // { text: 'Abstract', value: 'Abs', sortable: false},
        ],
        papers: [],
      }
    },
    created: function () {
    this.$http.get('/api/covid-19/total_literature').then((response) => {
      console.log(response.data); 
      this.papers = response.body;
    })
  }
  }
</script>

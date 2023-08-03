<template>
    <div>
        <h1 class="">Commits</h1>
        <div class="container mt-4 form-container">
            <div class="form-group">
            <label for="title">Title:</label>
            <input class="form-control" type="text" id="title" v-model="formData.title" placeholder="Title" required/>
            </div>

            <div class="form-group">
            <label for="category">Category:</label>
            <select class="form-control" id="category" v-model="formData.category"  required>
                <option disabled value="">Category</option>
                <option v-for="option in categoryOptions" :key="option.value" :value="option.value">{{ option.label }}</option>
            </select>
            </div>

            <div class="form-group">
            <label for="link">Link:</label>
            <input class="form-control" type="text" id="link" v-model="formData.link" placeholder="Link" required/>
            </div>

            <div class="form-group">
            <label for="description">Description:</label>
            <input class="form-control" type="text" id="description" v-model="formData.description" placeholder="Description" required/>
            </div>
            <br/>
            <button v-if="isEditing" @click="updateCommit" class="btn btn-primary">Update</button>
            <button v-if="isEditing" @click="cancelEdit" class="btn btn-primary">Cancel</button>
            <button v-else @click="addCommit" class="btn btn-primary">Submit</button>

        </div>
        <br/>
        <div v-if="commits.length > 0">
            <div class="row">
        <div class="col-md-3 mb-3">
          <label for="search-title">Search by Title:</label>
          <input
            class="form-control"
            type="text"
            id="search-title"
            v-model="searchTitle"
            @input="applySearch"
          />
        </div>

        <div class="col-md-3 mb-3">
          <label for="search-category">Search by Category:</label>
          <select
            class="form-control"
            id="search-category"
            v-model="searchCategory"
            @change="applySearch"
          >
            <option value="">All Categories</option>
            <option v-for="option in categoryOptions" :key="option.value" :value="option.value">
              {{ option.label }}
            </option>
          </select>
        </div>

        <div class="col-md-3 mb-3">
          <label for="search-link">Search by Link:</label>
          <input
            class="form-control"
            type="text"
            id="search-link"
            v-model="searchLink"
            @input="applySearch"
          />
        </div>

        <div class="col-md-3 mb-3">
          <label for="search-description">Search by Description:</label>
          <input
            class="form-control"
            type="text"
            id="search-description"
            v-model="searchDescription"
            @input="applySearch"
          />
        </div>
        <div class="col-md-3 mb-3">
          <button class="btn btn-secondary" @click="resetSearch">Reset Search</button>
        </div>
      </div>
            <table class="table">
                <thead>
                    <tr>
                    <th scope="col">Title</th>
                    <th scope="col">Category</th>
                    <th scope="col">Link</th>
                    <th scope="col">Description</th>
                    <th scope="col">Created</th>
                    <th scope="col">Updated</th>
                    </tr>
                </thead>
                <tbody>
                <tr v-for="commit in filteredCommits" :key="commit.id">
                    <td><a :href="commit.link" target="_blank">{{ commit.title }}</a></td>
                    <td>{{ commit.category }}</td>
                    <td>{{ commit.link }}</td>
                    <td>{{ commit.description }}</td>
                    <td>{{ commit.created_at }}</td>
                    <td>{{ commit.updated_at }}</td>
                    <td><button class="btn btn-secondary" @click="editCommit(commit.id)">Edit</button></td>
                    <td><button class="btn btn-danger" @click="deleteCommit(commit.id)">Delete</button></td>
                </tr>
                </tbody>
            </table>
            </div>
            <div v-else>
                <p>No commits found.</p>
            </div>
    </div>
</template>

<script >

const API_URL="http://localhost:3000/commits"

export default {
  data() {
    return {
      formData: {
        title: '',
        category: '',
        link: '',
        description: '',
      },
      editFormData: {
        id: '', // To store the commit ID being edited
        title: '',
        category: '',
        link: '',
        description: '',
      },

      searchTitle: '',
      searchCategory: '',
      searchLink: '',
      searchDescription: '',

      categoryOptions: [
        { value: 'nav', label: 'Nav' },
        { value: 'cover', label: 'Cover' },
        { value: 'banner', label: 'Banner' },
        { value: 'popup', label: 'Popup' },
        { value: 'about', label: 'About' },
        { value: 'slideshow', label: 'Slideshow' },
        { value: 'gallery', label: 'Gallery' },
        { value: 'menu/drinks', label: 'Menu/Drinks' },
        { value: 'events', label: 'Events' },
        { value: 'specials', label: 'Specials' },
        { value: 'reviews', label: 'Reviews' },
        { value: 'maps', label: 'Maps' },
        { value: 'contact', label: 'Contact' },
        { value: 'locations', label: 'Locations' },
        { value: 'form', label: 'Form' },
        { value: 'widget', label: 'Widget' },
        { value: 'custom page', label: 'Custom Page' },
        { value: 'custom section', label: 'Custom Section' },
        { value: 'fixes', label: 'Fixes' },
        { value: 'other', label: 'Other' },
      ],
      isEditing: false,
      commits: [],
      filteredCommits: [],
    };

    
  },
  computed: {
    
  },
  methods: {
    resetSearch() {
      // Clear all search input fields and reset the filteredCommits to all commits
      this.searchTitle = '';
      this.searchCategory = '';
      this.searchLink = '';
      this.searchDescription = '';
      this.filteredCommits = this.commits;
    },
    applySearch() {
      this.filteredCommits = this.commits.filter((commit) => {
        return (
          commit.title.toLowerCase().includes(this.searchTitle.toLowerCase()) &&
          commit.category.toLowerCase().includes(this.searchCategory.toLowerCase()) &&
          commit.link.toLowerCase().includes(this.searchLink.toLowerCase()) &&
          commit.description.toLowerCase().includes(this.searchDescription.toLowerCase())
        );
      });

      // Update the commits with the filtered commits
      this.filteredCommits = this.filteredCommits;
    },
    async fetchCommits() {
      try {
        const response = await fetch(API_URL);
        if (response.ok) {
          this.commits = await response.json();
        } else {
          console.error('Failed to fetch commits.', response);
        }
      } catch (error) {
        console.error('Error fetching commits:', error);
      }
      this.filteredCommits = this.commits
    },
    async addCommit() {
        try {
        const res = await fetch(API_URL, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(this.formData),
        });

        if (res.ok) {
        //   console.log('Commit submitted!');
          console.log(this.formData);

        this.fetchCommits();
          // Clear the form data after successful submission.
          this.formData.title = '';
          this.formData.category = '';
          this.formData.link = '';
          this.formData.description = '';
        } else {
          console.error('Failed to submit form.', res);
        }
      } catch (error) {
        console.error('Error submitting form:', error);
      }
    },

    async deleteCommit(commitId) {
      try {
        const response = await fetch(`${API_URL}/${commitId}`, {
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
          },
        });

        if (response.ok) {
          // If the commit was successfully deleted, remove it from the local commits array
          this.commits = this.commits.filter((commit) => commit.id !== commitId);
        } else {
          console.error('Failed to delete commit.', response);
        }
      } catch (error) {
        console.error('Error deleting commit:', error);
      }
    },

    async editCommit(commitId) {
      // Find the commit with the specified ID in the commits array
      const commitToEdit = this.commits.find((commit) => commit.id === commitId);
      if (!commitToEdit) {
        console.error('Commit not found.');
        return;
      }

      // Set the editFormData with the commit data
      this.editFormData = commitToEdit.id
      this.editFormData.title = commitToEdit.title
      this.editFormData.category = commitToEdit.category
      this.editFormData.link = commitToEdit.link
      this.editFormData.description = commitToEdit.description

      // Show the edit form
      this.isEditing = true;
    },
    async updateCommit() {
      try {
        const response = await fetch(`${API_URL}/${this.editFormData.id}`, {
          method: 'PUT', // Use 'PUT' or 'PATCH' depending on your Rails API setup
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(this.editFormData),
        });

        if (response.ok) {
          // Update the commits array with the edited commit data
          this.commits = this.commits.map((commit) =>
            commit.id === this.editFormData.id ? { ...this.editFormData } : commit
          );

          // Hide the edit form after successful update
          this.isEditing = false;
        } else {
          console.error('Failed to update commit.', response);
        }
      } catch (error) {
        console.error('Error updating commit:', error);
      }
    },
    cancelEdit() {
        this.isEditing = false
        this.formData.title = ''
        this.formData.category = ''
        this.formData.link = ''
        this.formData.description = ''
    },
  },
  created() {
    this.fetchCommits();
  }
};
</script>
<style scoped>
    .form-container {
        display: flex;
        justify-content: space-between;
        gap: 10px;
        align-items: center;
    }
    label {
        visibility: hidden;
    }
    .btn-primary {
        padding: 10px 40px;
        margin: 5px;
    }
</style>
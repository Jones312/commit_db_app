<template>
    <div class="modal" tabindex="-1" role="dialog" id="editModal">
        <div class="modal" tabindex="-1" role="dialog" id="editModal">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Edit Commit</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <!-- Add the edit form here -->
            <div class="form-group">
              <label for="edit-title">Title:</label>
              <input class="form-control" type="text" id="edit-title" v-model="editingCommit.title" />
            </div>
            <div class="form-group">
              <label for="edit-description">Description:</label>
              <input class="form-control" type="text" id="edit-description" v-model="editingCommit.description" />
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
            <button @click="updateCommit" class="btn btn-primary">Update</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['editingCommit'],
  methods: {
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
      this.$emit('commit-updated');
    },
  },
};
</script>

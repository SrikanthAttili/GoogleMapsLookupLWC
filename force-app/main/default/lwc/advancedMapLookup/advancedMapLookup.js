import { LightningElement, track, api } from "lwc";
import placeSearch from "@salesforce/apex/AddressSearchController.placeSearch";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class AdvancedMapLookup extends LightningElement {
  @track errors = [];
  @api notifyViaAlerts = false;

  handleSearch(event) {
    let searchKey = event.detail.searchTerm;
    console.log("#####" + JSON.stringify(event.detail.searchTerm));
    placeSearch({ searchPhrase: searchKey })
      .then(results => {
        this.template.querySelector("c-lookup").setSearchResults(results);
      })
      .catch(error => {
        this.notifyUser(
          "Lookup Error",
          "An error occured while searching with the lookup field.",
          "error"
        );
        // eslint-disable-next-line no-console
        console.error("Lookup error", JSON.stringify(error));
        this.errors = [error];
      });
  }

  notifyUser(title, message, variant) {
    if (this.notifyViaAlerts) {
      // eslint-disable-next-line no-alert
      alert(`${title}\n${message}`);
    } else {
      const toastEvent = new ShowToastEvent({ title, message, variant });
      this.dispatchEvent(toastEvent);
    }
  }

  handleSelectionChange() {
    this.errors = [];
  }

  checkForErrors() {
    const selection = this.template.querySelector("c-lookup").getSelection();
    if (selection.length === 0) {
      this.errors = [
        { message: "You must make a selection before submitting!" },
        { message: "Please make a selection and try again." }
      ];
    } else {
      this.errors = [];
    }
  }

  handleSubmit() {
    this.checkForErrors();
    if (this.errors.length === 0) {
      this.notifyUser("Success", "The form was submitted.", "success");
    }
  }
}

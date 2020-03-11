
function ing() {
  var ing_div = document.getElementById('for_ing');

  // var node = document.createElement("LI"); 
  // var textnode = document.createTextNode("Web Technology"); 

  ing_div.appendChild(textnode);
}










var current_count = 0

class Link {
  // head => current_count
  // current_count ++
  // data => (ingredient / direction)
  // next => next head (current_count)
  // if next == current_count then i'm the end
  constructor(head, data, prev, next){
    this.head = head;
    this.data = data;
    this.next = next;
    this.prev = prev
  }
}

class LinkedList {
  constructor(list_data){
    this.list = [];
    while(current_count < list_data.length){
      this.list.push(new Link(current_count, list_data[current_count], current_count-1, ++current_count));
    }
  }

  list_empty(){
    return this.list.length == 0;
  }

  new(data) {
    let last_link = this.find(current_count - 1);
    // debugger;
    // let i = this.insert(last_link, data);
    last_link.next = current_count;
    this.list.push(new Link(current_count++, data, current_count, last_link.head));
  }

  insert(current_link, data){
    if(this.list_empty()){
      return -1;
    }
    if(current_link.next == current_count){ // I am going to be the last one now
      new_link = new Link(current_count++, data, current_count, current_link.head);
      current_link.next = new_link.head;
      this.list.push(new_link);
    } else{
      let next_link = this.find(current_link.next);
      let new_link = new Link(current_count++, data, current_link.head, next_link.head);
      current_link.next = new_link.head;
      next_link.prev = new_link.head;
      let last_link = this.find(current_count-2);
      // debugger;
      last_link.next = current_count;
      this.list.push(new_link);
    }




  }

  remove(link, data){
    if(this.list_empty()){
      return -1;
    }
    if(this.list.length == 1){
      this.list = [];
    }
    // if my prev >= 0 it is not the first one
    // get the prev link
    if(link.prev >= 0){
      var prev_link = this.find(link.prev);
    } else { 
      let prev_link = null;
    }
    // if my next != current_count it is not the last one
    // get the next link
    if(link.next != current_count){
      var next_link = this.find(link.next);
    } else {
      let next_link = null;
    }
    // remove me from the array
    this.list.splice(link.head, 1);
    // the prev one's next == the next one's head if there is a next one, else prev one's next == current count
    if(!next_link){
      prev_link.next = current_count;
    } else {
      prev_link.next = next_link.head;
    }
    // the next one's prev == the previous one's head if there is a prev else next one's prev == -1
    if(!prev_link){
      next_link.prev = -1;
    } else {
      next_link.prev = prev_link.head;
    }
  }

  find(index){
    for(let i = 0; i < this.list.length; i++){
      if(index == this.list[i].head){
        return this.list[i];
      }
    }
  }

  find_by_next(index){
    for(let i = 0; i < this.list.length; i++){
      if(index == this.list[i].next){
        return this.list[i];
      }
    }
  }

  print(){
    for(let i = 1; i< this.list.length; i++){
      console.log(this.find_by_next(i).data);
    }
  }
}




class ParseData {
  constructor(i, d){
    this.ingredients = this.parse_ingredients(i);
    // console.log(this.ingredients);
    this.directions = this.parse_directions(d);
    // console.log(this.directions);
  }

  parse_ingredients(ing){
    let ing_array = []
    for(let i = 0; i < ing.length; i++){
      ing_array.push(ing[i].ingredient);
    }
    return ing_array;
  }

  parse_directions(dir){
    let dir_array = []
    for(let i = 0; i < dir.length; i++){
      dir_array.push(dir[i].direction);
    }
    return dir_array;
  }
}
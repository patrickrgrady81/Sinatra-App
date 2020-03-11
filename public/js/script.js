
function go() {
  let go_btn = document.querySelector('form');

  go_btn.onsubmit = function(e){
    e.preventDefault();
    console.log(e.target)
    // x is the object with all the properties for params
    let url = `/users/${user_name}/recipes/${recipe_name}`;
    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
        // 'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: JSON.stringify(x)
    }).then( /* do stuff */)
  }
}

function delete_me(index, type){
  console.log(index);
  console.log(type)
}

function add_one(index, type){
  console.log(index);
}


function populate(for_div, linkedList) {
  var the_div = document.getElementById(for_div);

  let new_p;
  let new_element;
  let new_btn_delete;
  let new_btn_add;
  let input_id;

  for(let i = 1; i <= linkedList.list.length; i++){
    new_p = document.createElement("P");
    
    new_element = document.createElement("INPUT");
    new_element.setAttribute("type", "text");
    new_element.setAttribute("value", linkedList.find_by_next(i).data);
    if(for_div == "for_ing"){
      input_id = `ing + ${i - 1}`;
    } else {
      input_id = `dir + ${i - 1}`;
    }
    new_element.setAttribute("id", input_id);


    new_btn_delete = document.createElement("INPUT");
    new_btn_delete.setAttribute("type", "button");
    new_btn_delete.setAttribute("value", "x");
    new_btn_delete.setAttribute("class", "delete-btn");
    // let data_id = i-1;
    // let list = linkedList;
    // data = {"id": data_id, "data_list": list};
    new_btn_delete.setAttribute("onClick", `delete_me(${i-1}, "${linkedList.type}")`);
    

    new_btn_add = document.createElement("INPUT");
    new_btn_add.setAttribute("type", "button");
    new_btn_add.setAttribute("value", "+");
    new_btn_add.setAttribute("class", "add-btn");
    new_btn_add.setAttribute("onClick", `add_one(${i-1}, "${linkedList.type}")`);

    new_p.appendChild(new_element);
    new_p.appendChild(new_btn_delete);
    new_p.appendChild(new_btn_add);
    the_div.appendChild(new_p);
  }
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
  constructor(list_data, type){
    this.list = [];
    while(current_count < list_data.length){
      this.list.push(new Link(current_count, list_data[current_count], current_count-1, ++current_count));
    }
    this.type = type;
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
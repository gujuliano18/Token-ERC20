// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


contract ERC20 {


      mapping(address => uint256 ) private _balances;
      mapping(address => mapping(address => uint256)) private _allowances;


      uint256 private _totalSupply;
      uint8 private _decimals;
      string private _symbol;
      string private _name;


      event Transfer(address indexed from, address indexed to, uint256 value);
      event Approval(address indexed owner, address indexed spender, uint256 value);

   constructor (){
     _name = "NAME_TOKEN";//Name of token
     _symbol = "SSS";//Symbol of token
     _decimals = 18;//Decimals default
     _totalSupply = 36000000000000000000000000000000;//Supply 36 trillions tokens 32 digits
     _balances[msg.sender] = _totalSupply;
     }


     /**
     * @dev Returns the name of the token.
     */
     function name() public view returns (string memory) {
       return _name;
     }


     /**
     * @return the symbol of the token.
     */
     function symbol() public view returns (string memory) {
       return _symbol;
     }


     /**
     * @return the number of decimals of the token.
     */
     function decimals() public view returns(uint8){
       return _decimals;
     }


     /**
     * @dev Returns the amount of tokens in existence.
     */
     function totalSupply() public view returns (uint256) {
       return _totalSupply;
     }


     /**
     * @dev Returns the amount of tokens owned by `account`.
     */
     function balanceOf(address _owner) public view returns (uint256) {
       return _balances[_owner];
     }


     /**
     * @dev Mint new tokens by `account`.
     */
     function mint(address account, uint256 amount) public virtual returns(bool) {
       _mint(account, amount);
       return true;
     }


     /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to `transfer`, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a `Transfer` event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
     function _transfer(address sender, address recipient, uint256 amount) internal {
         uint256 senderBalance = _balances[sender];
         require(senderBalance >= amount, "ERC20: transfer amount exeeds balance");

         unchecked{
             _balances[sender] = senderBalance - amount;
         }

         _balances[recipient] += amount;

         emit Transfer(sender, recipient, amount);
     }


     function transfer(address recipient, uint256 amount) public returns(bool){
         _transfer(msg.sender, recipient, amount);
       return true;
     }


     /**
     * @dev See `IERC20.transferFrom`.
     *
     * Emits an `Approval` event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of `ERC20`;
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `value`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
     function transferFrom(address sender, address repicipient, uint256 amount) public returns(bool){
       uint256 currentAllowance = _allowances[sender][msg.sender];
       require(currentAllowance >= amount, "ERC20: tranfer amount exceeds allowance");

       _transfer(sender, repicipient, amount);
       _approve(sender, msg.sender, currentAllowance - amount);
       return true;
     }


     /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
     function approve(address spender, uint256 amount) public returns(bool){
       _approve(msg.sender, spender, amount);
       return true;
     }


     /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
     function _approve(address owner, address spender, uint256 amount) internal {
       _allowances[owner][spender] = amount;

       emit Approval(owner, spender, amount);
     }

     
     /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
     function allowance(address owner, address spender) public view returns (uint256) {
       return _allowances[owner][spender];
     }


     /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
     function increaseAllowance(address spender, uint256 addedValue) public returns(bool){
       _approve(msg.sender, spender, _allowances[msg.sender][spender] += addedValue);
       return true;
     }

     /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool){
       uint256 currentAllowance = _allowances[msg.sender][spender];
       require(currentAllowance >= subtractedValue, "ERC20: decreased allowance belo zero");

       unchecked{_approve(msg.sender, spender, currentAllowance - subtractedValue);}
       return true;
     }


     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a `Transfer` event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
     function _mint(address account, uint256 amount) internal virtual {
       require(account != address(0), "ERC20: mint to the zero address");
       _totalSupply += amount;
       _balances[account] += amount;
       emit Transfer(address(0), account, amount);
     }
}//FECHA CONTRATO
//Token padrão, simples com todas as funções básicas e obrigatórias com algumas opcionais.
//com mint, sem burn.
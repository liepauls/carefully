# Carefully

Additional layer of security when performing actions through rails console in sensitive environments.

### Installation

##### Add to Gemfile
```
gem 'carefully'
```

##### Run from terminal
```
rails g carefully
```

Optionally you can edit config in `config/intializers/carefully.rb`

### Usage

Add this to models for which you want to be prompted when destroying it's instances:

```
include Carefully
```

You might as well include it in your ActiveRecord::Base wrapper class (like ApplicationRecord) to have it for all models.

##### Disabling the prompt

You can disable the prompting for blocks like this:
```
Carefully.allow_all do
  this.destroy
  that.destroy
  everything.destroy
end
```

None of these actions will require to be confirmed this way.

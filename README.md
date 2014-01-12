# Ancestry uniqueness

Provides an activerecord uniqueness validator for objects that are ordered in a tree using the [ancestry](https://github.com/stefankroes/ancestry) gem.

The gem is just a custom validator as described in the [Rails guides](http://edgeguides.rubyonrails.org/active_record_validations.html#custom-validators).

## Usage
After adding the gem to your project simply add `ancestry_uniqueness: true` as a parameter to the `validates` class method. E.g.:

```ruby
class Page < ActiveRecord::Base
  has_ancestry

  validates :slug, ancestry_uniqueness: true
end
```

This makes sure the object doesn't pass validation when the attribute (`slug` in this case) isn't unique among the object's siblings (i.e. within the same parent).

### With scope

If you want to scope your attribute pass a hash to `ancestry_uniqueness` like so:

```ruby
class Page < ActiveRecord::Base
  has_ancestry

  validates :slug, ancestry_uniqueness: {scope: :some_attribute}
end
```

## Compatibility
The gem depends on [ancestry](https://github.com/stefankroes/ancestry) 2 or greater. It should work in Rails 3 and Rails 4 apps.

Currently it's only tested in a Rails 4.0.1 app.

## Credits
I really should mention [groe](https://github.com/groe) as I based this gem heavily on his [code snippet](https://github.com/stefankroes/ancestry/issues/72#issuecomment-18242566).

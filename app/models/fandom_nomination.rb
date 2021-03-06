class FandomNomination < TagNomination
  belongs_to :tag_set_nomination
  has_one :owned_tag_set, :through => :tag_set_nomination

  has_many :character_nominations, :dependent => :destroy, :inverse_of => :fandom_nomination
  accepts_nested_attributes_for :character_nominations, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:tagname].blank? }

  has_many :relationship_nominations, :dependent => :destroy, :inverse_of => :fandom_nomination
  accepts_nested_attributes_for :relationship_nominations, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:tagname].blank? }


  def character_tagnames
    CharacterNomination.for_tag_set(owned_tag_set).where(:parent_tagname => tagname).value_of :tagname
  end

  def relationship_tagnames
    RelationshipNomination.for_tag_set(owned_tag_set).where(:parent_tagname => tagname).value_of :tagname
  end
  
  after_save :reject_children, :if => "rejected?"
  def reject_children
    character_nominations.each {|char| char.rejected = true; char.save}
    relationship_nominations.each {|rel| rel.rejected = true; rel.save}
    true
  end
  
  after_save :update_child_parent_tagnames, :if => "tagname_changed?"
  def update_child_parent_tagnames
    character_nominations.each {|char| char.parent_tagname = self.tagname; char.save}
    relationship_nominations.each {|rel| rel.parent_tagname = self.tagname; rel.save}
    true
  end
  
end